###############################################################################
# repository.tf - Set the GitHub Repository & branches infrastructure
# Copyright (C) 2022 - Sylvain Nieuwlandt
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

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