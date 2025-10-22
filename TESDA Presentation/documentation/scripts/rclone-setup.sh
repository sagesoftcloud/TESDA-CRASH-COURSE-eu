#!/bin/bash

# Rclone Setup Script for TESDA Project 1
# Run this script on the EC2 instance

set -e

echo "Starting Rclone setup on EC2 instance..."

# Step 1: Install Rclone
echo "Installing Rclone..."
curl https://rclone.org/install.sh | sudo bash

# Verify installation
rclone version

# Step 2: Create Rclone configuration
echo "Configuring Rclone for S3 access using IAM role..."

# Create rclone config directory
mkdir -p ~/.config/rclone

# Create rclone configuration file
cat > ~/.config/rclone/rclone.conf << EOF
[s3remote]
type = s3
provider = AWS
env_auth = true
region = us-east-1
location_constraint = us-east-1
acl = private
server_side_encryption = AES256
storage_class = STANDARD
EOF

echo "Rclone configuration created"

# Step 3: Test configuration
echo "Testing Rclone configuration..."

# Test listing buckets
echo "Available S3 buckets:"
rclone lsd s3remote:

# Create test file
echo "Hello from EC2 - $(date)" > test-connection.txt

# Test upload
echo "Testing file upload..."
rclone copy test-connection.txt s3remote:

# List files in bucket
echo "Files in S3 bucket:"
rclone ls s3remote:

# Test download
echo "Testing file download..."
mkdir -p downloads
rclone copy s3remote:test-connection.txt downloads/

# Verify download
if [ -f "downloads/test-connection.txt" ]; then
    echo "Download successful!"
    cat downloads/test-connection.txt
else
    echo "Download failed!"
    exit 1
fi

# Step 4: Create sample sync scenario
echo "Creating sample files for sync demonstration..."
mkdir -p local-files
for i in {1..3}; do
    echo "Sample file $i created on $(date)" > local-files/file-$i.txt
done

# Sync to S3
echo "Syncing local files to S3..."
rclone sync local-files/ s3remote:sync-demo/

# List synced files
echo "Synced files in S3:"
rclone ls s3remote:sync-demo/

# Step 5: Demonstrate bidirectional sync
echo "Demonstrating bidirectional sync..."

# Create a file in S3 (simulate remote change)
echo "Remote file created on $(date)" > remote-file.txt
rclone copy remote-file.txt s3remote:sync-demo/

# Sync from S3 to local
echo "Syncing from S3 to local..."
rclone sync s3remote:sync-demo/ local-files/

# Show local files
echo "Local files after sync:"
ls -la local-files/

echo ""
echo "=== Rclone Setup Complete ==="
echo "Configuration file: ~/.config/rclone/rclone.conf"
echo "Remote name: s3remote"
echo ""
echo "Common Rclone commands:"
echo "  List buckets: rclone lsd s3remote:"
echo "  List files: rclone ls s3remote:bucket-name/"
echo "  Copy file: rclone copy local-file.txt s3remote:bucket-name/"
echo "  Sync directory: rclone sync local-dir/ s3remote:bucket-name/remote-dir/"
echo "  Download file: rclone copy s3remote:bucket-name/file.txt local-dir/"
echo ""
echo "Rclone setup completed successfully!"

# Cleanup
rm -f test-connection.txt remote-file.txt
