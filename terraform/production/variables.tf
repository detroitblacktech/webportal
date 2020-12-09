variable "do_token" {

}

variable "slack_api_token" {

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
        default="staging"
}

variable "production" {
	default="false"
}

variable "staging" {
	default="false"
}

variable "role_id" {
	default=""
}

variable "secret_id" {
	default=""
}
