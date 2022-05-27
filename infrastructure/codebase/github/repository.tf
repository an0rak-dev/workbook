resource "github_repository" "sources_repo" {
  name        = "blog"
  description = "My personal blog"
  topics = [
    "blog", "javascript", "golang", "azure", "terraform"
  ]

  vulnerability_alerts   = true
  has_wiki               = false
  delete_branch_on_merge = true
  auto_init              = true
  archive_on_destroy     = true

  # Default values made explicit
  visibility         = "public"
  has_issues         = true
  has_projects       = true
  is_template        = false
  allow_merge_commit = true
  allow_rebase_merge = true
  allow_squash_merge = false
  allow_auto_merge   = false
}

resource "github_branch_default" "main" {
  repository = github_repository.sources_repo.name
  branch     = "main" # Created by github_repository.sources_repo.auto_init
}

resource "github_branch_protection" "main" {
  repository_id                   = github_repository.sources_repo.id
  pattern                         = "main"
  required_linear_history         = true
  require_conversation_resolution = true
  required_status_checks {
    strict = true
  }

  # Default values made explicit
  enforce_admins         = false
  require_signed_commits = false
  allows_deletions       = false
  allows_force_pushes    = false
}

output "remote-url" {
  value = github_repository.sources_repo.ssh_clone_url
}