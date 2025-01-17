
sg_name       = "my-security-group"                          #string
cidr          = "10.0.0.0/16"                             #number
port_number   = ["8000", "9000", "8080", "9090"]             #list(number)
instance_name = ["test-server", "dev-server", "prod-server"] #list(string)
instance_type_map = {
  "0" = "t2.nano"
  "1" = "t2.small"
"2" = "t2.micro" } #map(string)
#   The keys ("0", "1", "2") are strings.
#   The values ("t2.micro", "t2.small", "t2.medium") are also strings.


is_test_env = true


port1 = "80"   #number
port2 = "8080" #number
port3 = "9000" #number
port4 = "3000" #number

