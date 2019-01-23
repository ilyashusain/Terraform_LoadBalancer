module "mig1" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.14"
  region            = "${var.region}"
  zone              = "${var.zone2}"
  name              = "group1"
  compute_image     = "packer-1547996656"
  size              = 2
  service_port      = 80
  service_port_name = "http"
  http_health_check = false
  target_pools      = ["${module.gce-lb-fr1.target_pool}"]
  target_tags       = ["allow", "http-server"]
  ssh_source_ranges = ["0.0.0.0/0"]
  autoscaling        = true
  autoscaling_cpu = [{
    target = 0.8
  }]
}

module "mig2" {
  source            = "GoogleCloudPlatform/managed-instance-group/google"
  version           = "1.1.14"
  region            = "${var.region}"
  zone              = "${var.zone}"
  name              = "group2"
  compute_image     = "packer-1547982783"
  size              = 2
  service_port      = 80
  service_port_name = "http"
  http_health_check = false
  target_pools      = ["${module.gce-lb-fr2.target_pool}"]
  target_tags       = ["allow", "http-server"]
  ssh_source_ranges = ["0.0.0.0/0"]
  autoscaling       = true
  autoscaling_cpu   = [{
    target = 0.8
  }]
}

module "gce-lb-fr1" {
  source       = "GoogleCloudPlatform/lb/google"
  region       = "${var.region}"
  name         = "group1-lb"
  service_port = "${module.mig1.service_port}"
  target_tags  = ["${module.mig1.target_tags}"]
}

module "gce-lb-fr2" {
  source       = "GoogleCloudPlatform/lb/google"
  region       = "${var.region}"
  name         = "group2-2b"
  service_port = "${module.mig2.service_port}"
  target_tags  = ["${module.mig2.target_tags}"]
}

module "gce-lb-http1" {
  source            = "GoogleCloudPlatform/lb-http/google"
  name              = "group1-http-lb"
  target_tags       = "${module.mig1.target_tags}"

backends          = {
    "0" =
      { group = "${module.mig1.instance_group}" }
    ,
  }


  backend_params    = [
    # health check path, port name, port number, timeout seconds.
    "/health_check,http,80,10"
  ]
}

module "gce-lb-http2" {
  source            = "GoogleCloudPlatform/lb-http/google"
  name              = "group2-http-lb"
  target_tags       = "${module.mig2.target_tags}"

backends          = {
    "0" =
      { group = "${module.mig2.instance_group}" }
    ,
  }


  backend_params    = [
    # health check path, port name, port number, timeout seconds.
    "/health_check,http,80,10"
  ]
}

resource "google_compute_http_health_check" "default" {
  name         = "authentication-health-check"
  request_path = "/health_check"

  timeout_sec        = 1
  check_interval_sec = 1
}
