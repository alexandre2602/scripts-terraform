resource "aws_sqs_queue" "sqs_queue" {
  name                      = "gudiao-labs-sqs-queue.fifo"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  fifo_queue = true

  tags = {
    Name = "gudiao-labs-sqs-queue"
    Environment = "dev"
  }
}