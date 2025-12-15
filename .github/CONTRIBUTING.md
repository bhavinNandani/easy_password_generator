# Contributing to PassForge

Thank you for your interest in contributing to PassForge! We welcome bug reports, feature requests, and pull requests.

## getting Started

1.  **Fork the repository** on GitHub.
2.  **Clone your fork** locally:
    ```bash
    git clone https://github.com/your-username/passforge.git
    cd passforge
    ```
3.  **Install dependencies**:
    ```bash
    bundle install
    ```
4.  **Create a branch** for your feature or bug fix:
    ```bash
    git checkout -b my-new-feature
    ```

## Coding Standards

-   Follow standard Ruby coding conventions.
-   Ensure your code matches the existing style (we use RuboCop).
-   Run `bundle exec rubocop` to check for style issues.

## Testing

-   We use **RSpec** for testing.
-   Please ensure all tests pass before submitting a PR:
    ```bash
    bundle exec rspec
    ```
-   Add new tests for any new features or bug fixes.

## Submitting a Pull Request

1.  Push your branch to your fork on GitHub.
2.  Open a Pull Request against the `main` branch of the original repository.
3.  Fill out the Pull Request template with details about your changes.
4.  Wait for review and address any feedback.

## Reporting Bugs

Please use the [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md) when opening a new issue.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE.txt).
