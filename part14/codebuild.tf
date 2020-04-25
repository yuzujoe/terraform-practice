module "codebuild_role" {
  source     = "./iam_role"
  name       = "codebuild"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy_document.codebuild.json
}

module "codepipeline_role" {
  source     = "./iam_role"
  name       = "codepipeline"
  identifier = "codepipeline.amazonaws.com"
  policy     = data.aws_iam_policy_document.codepipeline.json
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObeject",
      "s3:GetObeject",
      "s3:GetObejectVersion",
      "s3:GetBucketVersioning",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "iam:PassRole",
    ]
  }
}

resource "aws_codebuild_project" "example" {
  name         = "example"
  service_role = module.codebuild_role.iam_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type = "CODEPIPELINE"
  }
}

resource "aws_s3_bucket" "artifact" {
  bucket = "aritifact-pragmatic-terraform"

  lifecycle_rule {
    enabled = false

    expiration {
      days = "180"
    }
  }
}

resource "aws_codepipeline" "example" {
  name     = "example"
  role_arn = module.codepipeline_role.iam_role_arn

  artifact_store {
    location = aws_s3_bucket.artifact.id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      category         = "Source"
      name             = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = 1
      output_artifacts = ["Source"]

      configuration {
        Owner  = "your-github-name"
        Repo   = "your-repository"
        Branch = "master"
        //Codepipelineの起動の設定、Githubからのwebhookで行うのでfalseにする
        PollForSourceChanges = false
      }
    }
  }

  stage {
    //CodeBuildの指定
    name = "Build"
    action {
      category         = "Build"
      name             = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["Source"]
      output_artifacts = ["Build"]

      configuration {
        ProjectName = aws_codebuild_project.example.id
      }
    }
  }

  stage {
    // Deploy先のECSクラスタとECSサービスを指定する
    name = "Deploy"

    action {
      category        = "Deploy"
      name            = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = 1
      input_artifacts = ["Build"]

      configuration {
        ClusterName = aws_ecs_cluster.example.name
        ServiceName = aws_ecs_service.example.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "example" {
  authentication  = "GITHUB_HMAC"
  name            = "example"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.example.name

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }

  authentication_configuration {
    secret_token = "VeryRandomStringMoreThan20Byte!"
  }
}

provider "github" {
  organization = "your-github-team"
}

resource "github_repository_webhook" "example" {
  // pushに反応するように指定
  events     = ["push"]
  repository = "your-repository"

  configuration {
    url          = aws_codepipeline_webhook.example.url
    secret       = "VeryRandomStringMoreThan20byte!"
    content_type = "json"
    insecure_ssl = false
  }
}
