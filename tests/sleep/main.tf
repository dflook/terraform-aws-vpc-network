resource "time_sleep" "wait" {
  create_duration = var.time
}

variable "time" {
  type    = string
  default = "600s"
}
