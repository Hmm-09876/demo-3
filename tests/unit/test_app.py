import threading, time, urllib.request, os, json, sys

sys.path.insert(0, os.path.abspath("src/demo_app"))
from app import run


def start_local_server(port=8080):
    ready_event = threading.Event()
    thr = threading.Thread(target=run, kwargs={"port": port, "ready_event": ready_event}, daemon=True)
    thr.start()
    if not ready_event.wait(timeout=5):
        time.sleep(1)
    return thr


def test_health_check():
    thr = start_local_server(8080)
    try:
        deadline = time.time() + 5
        resp = None
        while time.time() < deadline:
            try:
                resp = urllib.request.urlopen("http://localhost:8080/health", timeout=1)
                break
            except Exception:
                time.sleep(0.1)
        assert resp is not None, "Failed to connect to the server"
        body = resp.read().decode()
        data = json.loads(body)
        assert resp.status == 200
        assert data.get("status") == "ok"
    finally:
        pass