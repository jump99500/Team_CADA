resource "aws_key_pair" "id_rsa" {
  key_name = var.key.name
  public_key = file("./id_rsa.pub")
}