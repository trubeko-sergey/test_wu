terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.88.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1g35nhp99idkhi5kja9"     //ID облака
  folder_id                = "b1g36tkee54c3so0d7r7"           //ID Каталога
  zone                     = "ru-central1-a"
}
resource "yandex_vpc_network" "network" {
  name = "my-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "mu-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.0.0/24"]
}
resource "yandex_compute_instance_group" "mygroup" {
  name                = "test-ig"
  folder_id           = "b1g36tkee54c3so0d7r7"
  service_account_id  = "ajeh4fgcg9na46evbk9e"
  deletion_protection = true
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd89jk9j9vifp28uprop"
        //size     = 4
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network.id}"
      subnet_ids = ["${yandex_vpc_subnet.subnet.id}"]
    }
    labels = {
      label1 = "label1-value"
      label2 = "label2-value"
    }
    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 10
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 0
    max_creating    = 10
    max_expansion   = 2
    max_deleting    = 0
  }
}


