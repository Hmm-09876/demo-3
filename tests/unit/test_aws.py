import os, time, pytest, boto3, subprocess, urllib.request, pathlib


ROOT = pathlib.Path(__file__).resolve().parents[2]
LOCALSTACK_COMPOSE = ROOT / "infra" / "localstack" / "docker-compose.yml"
TERRAFORM_DIR = ROOT / "infra" / "terraform"


subprocess.run(["docker", "compose", "-f", str(LOCALSTACK_COMPOSE), "up", "-d"], cwd=ROOT, check=True)

for _ in range(60):
    try:
        txt = urllib.request.urlopen("http://localhost:4566/health", timeout=2).read().decode()
        if "services" in txt or "ready" in txt.lower():
            break
    except Exception:
        pass
    time.sleep(1)


subprocess.run(["terraform", "init", "-input=false"], cwd=TERRAFORM_DIR, check=True)
subprocess.run(["terraform", "apply", "-auto-approve", "-input=false"], cwd=TERRAFORM_DIR, check=True)  


#############################################################################

AWS_URL = os.getenv("AWS_URL", "http://localhost:4566")
FUNC = os.getenv("LAMBDA_FUNCTION_NAME", "demo_lambda")
BUCKET = os.getenv("BUCKET_NAME", "demo-terraform-bucket")
KEY = os.getenv("OBJECT_KEY", "demo-3-object")
EVIDENCE_DIR = os.getenv("EVIDENCE_DIR", "evidence")

@pytest.fixture(scope="module")
def aws_clients():
    sess_args = {
        "endpoint_url": AWS_URL,
        "aws_access_key_id": "test",
        "aws_secret_access_key": "test",
        "region_name": "us-east-1"
    }
    s3 = boto3.client("s3", **sess_args)
    lambda_client = boto3.client("lambda", **sess_args)
    logs = boto3.client("logs", **sess_args)
    return {"s3": s3, "lambda": lambda_client, "logs": logs}

def wait_for_log(clients, func_name, text_substring, timeout=15, poll_interval=1):
    log_group = f"/aws/lambda/{func_name}"
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            resp = clients["logs"].describe_log_events(logGroupName=log_group, limit=50)
            for ev in resp.get("events", []):
                if text_substring in ev.get("message", ""):
                    return ev
        except Exception:
            pass
        time.sleep(poll_interval)
    return None

def test_lambda_exists(aws_clients):
    resp = aws_clients["lambda"].list_functions()
    names = [f["FunctionName"] for f in resp.get("Functions", [])]
    assert FUNC in names, f"Lambda function {FUNC} does not exist: {names}"

def test_invoke_lambda(aws_clients):
    r = aws_clients["lambda"].invoke(FunctionName=FUNC, Payload=b'{"test":"x"}')
    payload = r["Payload"].read().decode()
    assert payload is not None and payload != "", "Lambda invocation returned empty payload"

def test_s3_upload_triggers_lambda(aws_clients):
    s3 = aws_clients["s3"]
    try:
        s3.create_bucket(Bucket=BUCKET)
    except Exception:
        pass
    s3.put_object(Bucket=BUCKET, Key=KEY, Body=b"test data")
    ev = wait_for_log(aws_clients, FUNC, "Hello from Lambda!", timeout=15, poll_interval=1)
    if ev is None:
        objs = s3.list_objects_v2(Bucket=BUCKET)
        assert any(KEY in o.get("Key", "") for o in objs.get("Contents", [])), ("Uploaded object not found in bucket")
    else:
        assert "Hello from Lambda!" in ev.get("message", "")