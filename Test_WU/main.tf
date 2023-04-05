// Configure the Yandex.Cloud provider
provider "yandex" {
  token                    = "auth_token_here"
  service_account_key_file = "path_to_service_account_key_file"
  cloud_id                 = "b1g35nhp99idkhi5kja9"     //ID облака
  folder_id                = "b1g36tkee54c3so0d7r7"           //ID Каталога
  zone                     = "ru-central1-a"
}

// Create a new instance
resource "yandex_compute_instance" "default" {
  //...
}