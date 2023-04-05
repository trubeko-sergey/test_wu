// Configure the Yandex.Cloud provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1g35nhp99idkhi5kja9"     //ID облака
  folder_id                = "b1g36tkee54c3so0d7r7"           //ID Каталога
  zone                     = "ru-central1-a"
}

//Создание ресурса -> сети
resource "yandex_vpc_network" "test-lan" {
  name = "test-wu"
}
//Подсети

resource "yandex_vpc_subnet" "subnet-wu" {
  v4_cidr_blocks = ["192.168.0.0/24"]
  network_id     = "${yandex_vpc_network.test-lan.id}"
}

//Создание инстансов
resource "yandex_compute_instance" "trubeko" {
  name        = "test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd89jk9j9vifp28uprop"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-wu.id}"
  }
  
  metadata = {
    ssh-keys = "ubuntu:${file("/root/.ssh/id_rsa.pub")}"
    //user-data = "${file("init.sh")}" //Согласно документации Яндек.Cloud добавляем скрипт для выполнения постинсталл опеараций
  }
  deploy_policy {
    max_unavailable = 2
    max_creating = 2
    max_expansion = 2
    max_deleting = 2
  }
}
// Create a new instance
//resource "yandex_compute_instance" "default" {
//  
//}