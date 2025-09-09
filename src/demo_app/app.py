from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import os, json, signal

PORT = int(os.getenv("PORT", "8080"))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health" or self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"status": "ok"}).encode())
        else:
            self.send_response(404)
            self.end_headers()


def run(port=None, ready_event=None):
    port = port or PORT
    server = ThreadingHTTPServer(("", port), Handler)
    if ready_event is not None:
        ready_event.set()
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        try:
            server.server_close()
        except Exception:
            pass


if __name__ == "__main__":
    def _shutdown(signum, frame):
        raise KeyboardInterrupt()
    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)
    print(f"Starting server on port {PORT}")
    run()