workflow "Push it" {
  resolves = ["Upgrade to Python 3"]
  on = "push"
}

action "Upgrade to Python 3" {
  secrets = ["GITHUB_TOKEN"]
  uses = "cclauss/Upgrade-to-Python3@master"
}

workflow "on push" {
  resolves = ["Python Style Checker"]
  on = "push"
}

action "Python Style Checker" {
  uses = "andymckay/pycodestyle-action@master"
}

workflow "Lint Workflow" {
  on = "push"
  resolves = ["Lint"]
}

action "Lint" {
  uses = "lgeiger/pyflakes-action@master"
}
