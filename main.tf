resource "aws_instance" "app_server" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t3.nano"

  tags = {
    Name  = "ExampleAppServerInstance"
    Owner = ""
  }
}
