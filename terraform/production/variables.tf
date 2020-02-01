variable "do_token" {

}

variable "prefix" {
	default=""
}

variable "pvt_key" {
  default = "~/.ssh/dbt_dev"
}

variable "dropletname" {
  default = "webserver"
}

variable "number_of_servers" {
  default = "1"
}

variable "repo" {
        default="https://github.com/detroitblacktech/webportal.git"
}

variable "branch" {
        default="master"
}

variable "production_ip" {
	default="104.248.108.28"
}
