resource "aws_vpc" "main1" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "sbnt1" {
  vpc_id     = aws_vpc.main1.id
  cidr_block = "192.168.8.0/22"
  map_public_ip_on_launch = true
  tags = {
    
    Name = "pub-sbnt1"
  }
}

resource "aws_key_pair" "terraformkey" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJgMgv/+70iuAhIZrxNpWlhtPq7W4tt4yY/JN2irAEKAdm49g1ruRo48Ter9kTSanFXwOr3yykodXw/lcIuCdabYbZr4oJkDTpYNGk5JE5ZmFXImisWZLMhFvkt02/53pWDh/sE4oF6ayk1jET1WYk0wCD8SX1H4B7NmGSP+1GBltheN45vEfZcYgykbRRbMUxffr6kwQn36xL3WyQfPS2BrXOLf+gg0k7Za7oIGl/Vrao+drKKfifdSUuxQ6sasd0+LMH8s1rysvVXlVBe533sOS6dqnYZoIIW1iE+EaCKthPj+MvMt5u3ZPh1xPiMnKVQ6BM/YtkZwEILHwRDaH9efy1znsHGEycYxsvHkhvGP1VQ9utcGwW7scc1GXvS516SJ0Q/0ewky0dPSFtuEPmYzySaE2xaVCKJwWNjmniddVdVsh5jKuCacrbK/zf7QVgRGJLgI+6j69x60/Yvcdv16+O3no31+N85DfcXxPHolHjD+YunDpmbv0qU4AXYwM= asif@DESKTOP-DA0TOMO"
  }

  resource "aws_instance" "jenkin-server" {
  ami          = "ami-0440d3b780d96b29d"
  instance_type = "t2.xlarge"
    subnet_id     = aws_subnet.sbnt1.id
    key_name = aws_key_pair.terraformkey.key_name
  tags = {

    Name = "jenkin-server"
  }
}


resource "aws_route_table" "RTB-1" {
  vpc_id = aws_vpc.main1.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW1.id
  }
route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "RTB-pub"
  }
}

resource "aws_route_table_association" "RTB-ASTN-PVT1" {
  subnet_id      = aws_subnet.sbnt1.id
  route_table_id = aws_route_table.RTB-1.id
}

resource "aws_internet_gateway" "IGW1" {
  vpc_id = aws_vpc.main1.id

  tags = {
    Name = "IGW1"
  }
}
 

