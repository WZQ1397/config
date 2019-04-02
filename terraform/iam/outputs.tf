output "all_arns" {
    value = ["${aws_iam_user.example.*.arn}"]
}
