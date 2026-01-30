#!/bin/bash

# ================================================================
# Dask ETL Pipeline - Environment Setup Script
# ================================================================
# This script automates the installation of all required dependencies
# for the distributed data processing pipeline.
#
# Author: Your Name
# Date: January 2026
# Python Version: 3.8+
# ================================================================

set -e  # Exit on any error

# Color codes for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${2}${1}${NC}"
}

print_header() {
    echo ""
    echo "================================================================"
    print_message "$1" "${BLUE}"
    echo "================================================================"
    echo ""
}

print_success() {
    print_message "✓ $1" "${GREEN}"
}

print_warning() {
    print_message "⚠ $1" "${YELLOW}"
}

print_error() {
    print_message "✗ $1" "${RED}"
}

# ================================================================
# Check Prerequisites
# ================================================================

print_header "Dask ETL Pipeline - Environment Setup"

print_message "Checking prerequisites..." "${BLUE}"

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
REQUIRED_VERSION="3.8"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then 
    print_success "Python $PYTHON_VERSION detected"
else
    print_error "Python $REQUIRED_VERSION or higher is required. Found: $PYTHON_VERSION"
    exit 1
fi

# Check available memory
if command -v free &> /dev/null; then
    TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
    if [ "$TOTAL_MEM" -lt 8 ]; then
        print_warning "Only ${TOTAL_MEM}GB RAM available. 8GB+ recommended for optimal performance."
    else
        print_success "Memory check passed: ${TOTAL_MEM}GB available"
    fi
fi

# Check disk space
AVAILABLE_SPACE=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$AVAILABLE_SPACE" -lt 10 ]; then
    print_warning "Only ${AVAILABLE_SPACE}GB disk space available. 10GB+ recommended."
else
    print_success "Disk space check passed: ${AVAILABLE_SPACE}GB available"
fi

echo ""
sleep 1

# ================================================================
# Step 1: Update pip
# ================================================================

print_header "Step 1: Updating pip"

python3 -m pip install --upgrade pip --break-system-packages --quiet
if [ $? -eq 0 ]; then
    print_success "pip updated successfully"
else
    print_error "Failed to update pip"
    exit 1
fi

sleep 1

# ================================================================
# Step 2: Install Core Data Processing Libraries
# ================================================================

print_header "Step 2: Installing Core Data Processing Libraries"

print_message "Installing Dask framework..." "${BLUE}"
pip install dask[complete] --break-system-packages --quiet
print_success "Dask installed"

print_message "Installing Pandas..." "${BLUE}"
pip install pandas --break-system-packages --quiet
print_success "Pandas installed"

print_message "Installing NumPy..." "${BLUE}"
pip install numpy --break-system-packages --quiet
print_success "NumPy installed"

sleep 1

# ================================================================
# Step 3: Install Distributed Computing Components
# ================================================================

print_header "Step 3: Installing Distributed Computing Tools"

print_message "Installing Dask Distributed..." "${BLUE}"
pip install distributed --break-system-packages --quiet
print_success "Distributed computing tools installed"

print_message "Installing Dask-ML for machine learning..." "${BLUE}"
pip install dask-ml --break-system-packages --quiet
print_success "Dask-ML installed"

sleep 1

# ================================================================
# Step 4: Install Visualization Libraries
# ================================================================

print_header "Step 4: Installing Visualization Libraries"

print_message "Installing Matplotlib..." "${BLUE}"
pip install matplotlib --break-system-packages --quiet
print_success "Matplotlib installed"

print_message "Installing Seaborn..." "${BLUE}"
pip install seaborn --break-system-packages --quiet
print_success "Seaborn installed"

print_message "Installing Bokeh (for Dask dashboard)..." "${BLUE}"
pip install bokeh --break-system-packages --quiet
print_success "Bokeh installed"

sleep 1

# ================================================================
# Step 5: Install Jupyter Environment
# ================================================================

print_header "Step 5: Installing Jupyter Environment"

print_message "Installing Jupyter Notebook..." "${BLUE}"
pip install jupyter --break-system-packages --quiet
print_success "Jupyter installed"

print_message "Installing Notebook extensions..." "${BLUE}"
pip install notebook --break-system-packages --quiet
print_success "Notebook extensions installed"

print_message "Installing IPython kernel..." "${BLUE}"
pip install ipykernel --break-system-packages --quiet
print_success "IPython kernel installed"

sleep 1

# ================================================================
# Step 6: Install Additional Utilities
# ================================================================

print_header "Step 6: Installing Additional Utilities"

print_message "Installing scikit-learn..." "${BLUE}"
pip install scikit-learn --break-system-packages --quiet
print_success "scikit-learn installed"

print_message "Installing openpyxl (Excel support)..." "${BLUE}"
pip install openpyxl --break-system-packages --quiet
print_success "Excel support added"

print_message "Installing toolz (functional utilities)..." "${BLUE}"
pip install toolz --break-system-packages --quiet
print_success "Toolz installed"

sleep 1

# ================================================================
# Step 7: Verify Installation
# ================================================================

print_header "Step 7: Verifying Installation"

echo "Checking installed packages..."
echo ""

# Create verification script
cat > /tmp/verify_installation.py << 'EOF'
import sys

packages = {
    'dask': 'Dask',
    'distributed': 'Dask Distributed',
    'pandas': 'Pandas',
    'numpy': 'NumPy',
    'matplotlib': 'Matplotlib',
    'seaborn': 'Seaborn',
    'sklearn': 'scikit-learn',
    'bokeh': 'Bokeh',
    'jupyter': 'Jupyter'
}

all_good = True
for module, name in packages.items():
    try:
        __import__(module)
        version = __import__(module).__version__
        print(f"✓ {name:20s} v{version}")
    except ImportError:
        print(f"✗ {name:20s} NOT INSTALLED")
        all_good = False

sys.exit(0 if all_good else 1)
EOF

python3 /tmp/verify_installation.py
VERIFY_STATUS=$?

rm /tmp/verify_installation.py

echo ""

if [ $VERIFY_STATUS -eq 0 ]; then
    print_success "All packages verified successfully!"
else
    print_error "Some packages failed verification. Please check the output above."
    exit 1
fi

# ================================================================
# Step 8: Create Project Directories
# ================================================================

print_header "Step 8: Setting Up Project Structure"

mkdir -p data outputs
print_success "Created data/ directory for datasets"
print_success "Created outputs/ directory for results"

# ================================================================
# Setup Complete
# ================================================================

print_header "Setup Complete!"

cat << 'EOF'

   ___          _     
  |   \ __ _ __| |__  
  | |) / _` (_-< / /  
  |___/\__,_/__/_\_\  
                      
  ETL Pipeline Ready!

EOF

print_success "Environment setup completed successfully!"
echo ""
print_message "Next Steps:" "${YELLOW}"
echo "  1. Launch Jupyter Notebook:"
echo "     $ jupyter notebook"
echo ""
echo "  2. Open the pipeline notebook:"
echo "     dask_etl_pipeline.ipynb"
echo ""
echo "  3. Access Dask Dashboard (once cluster is running):"
echo "     http://localhost:8787"
echo ""
print_message "Quick Start:" "${YELLOW}"
echo "  Run all cells in the notebook to:"
echo "  • Generate 10M row sample dataset"
echo "  • Execute parallel ETL transformations"
echo "  • Compare Dask vs Pandas performance"
echo "  • Generate visualizations and reports"
echo ""
print_message "Helpful Resources:" "${BLUE}"
echo "  • Project README: README.md"
echo "  • Technical Docs: DOCUMENTATION.md"
echo "  • Dask Docs: https://docs.dask.org"
echo ""
print_message "System Information:" "${GREEN}"
echo "  Python Version: $PYTHON_VERSION"
echo "  Available Memory: ${TOTAL_MEM:-Unknown}GB"
echo "  Free Disk Space: ${AVAILABLE_SPACE:-Unknown}GB"
echo ""

# Optional: Display CPU info
if command -v nproc &> /dev/null; then
    CPU_CORES=$(nproc)
    print_message "  CPU Cores: $CPU_CORES" "${GREEN}"
    echo "  Recommended Dask workers: $((CPU_CORES - 1))"
fi

echo ""
print_message "Happy Data Processing! 🚀" "${BLUE}"
echo ""
echo "================================================================"
