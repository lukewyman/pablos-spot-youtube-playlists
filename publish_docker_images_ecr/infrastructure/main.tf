resource "aws_ecr_repository" "hello_lambda" {
    name = "hello-lambda-docker-image"
}


resource "docker_registry_image" "hello_lambda" {
    name = "${aws_ecr_repository.hello_lambda.repository_url}:latest"

    build {
        context = "../app/hello_world"
        dockerfile = "Dockerfile"
    }
}
