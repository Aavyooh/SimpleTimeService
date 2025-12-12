from flask import Flask, request, Response
from datetime import datetime
import json

app = Flask(__name__)

@app.route("/", methods=["GET"])
def index():
    # Current timestamp
    timestamp = datetime.utcnow().isoformat() + "Z"

    # Detect IP
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        ip = forwarded.split(",")[0].strip()
    else:
        ip = request.remote_addr

    # Build response dictionary (your required order)
    data = {
        "timestamp": timestamp,
        "ip": ip
    }

    # Pretty JSON output
    pretty_json = json.dumps(data, indent=2)

    return Response(pretty_json, mimetype="application/json")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)

