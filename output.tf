output "password" {
  description = "password gpg key output of IAM User"
  value       = aws_iam_user_login_profile.useradmin_login.encrypted_password
}
output "user" {
  description = "Name of IAM User"
  value       = aws_iam_user.useradmin.name

}