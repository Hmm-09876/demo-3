set -euo pipefail

echo "Installing dependencies..."
pip install -r src/demo_app/requirements.txt

echo "Running the application..."
export PORT=${PORT:-9000}
python src/demo_app/app.py
