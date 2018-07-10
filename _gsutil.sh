function install_google_cloud_sdk() {
  if test -e /etc/apt/sources.list.d/google-cloud-sdk.list;
  then
    echo "google cloud sdk already installed."
    return
  fi
# Add the Cloud SDK distribution URI as a package source
apt-get install --no-install-recommends -y lsb-release
echo "deb http://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Update and install the Cloud SDK
apt-get update
apt-get install -y --no-install-recommends google-cloud-sdk\
  google-cloud-sdk-app-engine-python\
  google-cloud-sdk-app-engine-python-extras\
  google-cloud-sdk-app-engine-go\
  google-cloud-sdk-datastore-emulator
}

install_google_cloud_sdk

##/End gsutil

