# Contributing to Ray Chad

Thank you for your interest in contributing to Ray Chad! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please be respectful and constructive in all interactions.

## Ways to Contribute

### 1. Report Bugs

Found a bug? Help us improve by reporting it:

1. Check existing issues to avoid duplicates
2. Provide a clear title and description
3. Include steps to reproduce the issue
4. Specify your environment (OS, Docker version, etc.)
5. Include error logs if available

**Report a bug**: [Open an issue](https://github.com/newssungoldentoday-dev/raychd/issues/new?labels=bug)

### 2. Suggest Enhancements

Have an idea for improvement?

1. Check existing issues and discussions
2. Describe the enhancement clearly
3. Explain why it would be useful
4. Provide examples if possible

**Suggest enhancement**: [Open an issue](https://github.com/newssungoldentoday-dev/raychd/issues/new?labels=enhancement)

### 3. Improve Documentation

Documentation improvements are always welcome:

- Fix typos or unclear explanations
- Add examples or clarifications
- Improve README and guides
- Add troubleshooting tips

### 4. Submit Code Changes

Interested in coding? Follow these steps:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Development Setup

### Prerequisites

- Git
- Bash shell
- Docker (recommended)
- Text editor or IDE

### Local Development

1. **Fork and clone**

```bash
git clone https://github.com/YOUR-USERNAME/raychd.git
cd raychd
```

2. **Create a feature branch**

```bash
git checkout -b feature/your-feature-name
```

3. **Make your changes**

```bash
# Edit files, test locally
./start.sh
# Test your changes
./stop.sh
```

4. **Commit with clear messages**

```bash
git commit -m "Add: Clear description of your changes"
```

5. **Push to your fork**

```bash
git push origin feature/your-feature-name
```

6. **Create a pull request**

Visit the main repository and click "New Pull Request"

## Coding Standards

### Shell Script Guidelines

- Use bash-compatible syntax (`#!/bin/bash`)
- Add comments for complex logic
- Use meaningful variable names
- Follow consistent indentation (2 or 4 spaces)
- Quote variables: `"$variable"` not `$variable`

Example:

```bash
#!/bin/bash
# Description of what this script does

# Set error handling
set -euo pipefail

# Define configuration
SERVER_PORT=${SERVER_PORT:-6667}

# Main logic with comments
if [[ -f "$CONFIG_FILE" ]]; then
    # Load configuration
    source "$CONFIG_FILE"
fi
```

### Dockerfile Guidelines

- Use official base images
- Keep layers minimal
- Add comments for clarity
- Use `.dockerignore` to exclude unnecessary files
- Follow Docker best practices

Example:

```dockerfile
FROM alpine:latest

# Set working directory
WORKDIR /app

# Install dependencies
RUN apk add --no-cache bash curl

# Copy application
COPY . /app/

# Expose IRC port
EXPOSE 6667

# Run application
CMD ["./start.sh"]
```

## Testing

### Manual Testing

1. **Start the server**

```bash
./start.sh
```

2. **Connect with IRC client**

```bash
# Terminal-based
irssi -c localhost -p 6667
```

3. **Test functionality**

- Connect/disconnect
- Join/leave channels
- Send messages
- Test error cases

4. **Check logs for errors**

```bash
tail -f logs/raychd.log
```

### Docker Testing

```bash
# Build image
docker build -t raychd:test .

# Run container
docker run -it --rm -p 6667:6667 raychd:test

# Test connectivity
irssi -c localhost -p 6667
```

## Pull Request Process

1. **Before submitting**
   - Test your changes thoroughly
   - Update documentation if needed
   - Check for any obvious issues

2. **PR description should include**
   - Clear title describing the change
   - Description of what changed and why
   - Related issue numbers (if applicable)
   - Steps to test the changes
   - Any breaking changes or notes

3. **PR template**

```markdown
## Description
Brief description of changes

## Related Issues
Closes #123

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation improvement
- [ ] Performance improvement

## Testing
How to test these changes:
1. Start server: `./start.sh`
2. Connect with IRC client
3. Verify functionality

## Checklist
- [ ] Changes follow coding standards
- [ ] Documentation updated
- [ ] Tested locally
- [ ] No breaking changes
```

4. **Review process**
   - Maintainers will review your PR
   - You may be asked to make changes
   - Once approved, your PR will be merged

## Commit Message Guidelines

Use clear, descriptive commit messages:

```
Add: New feature description
Fix: Bug fix description
Improve: Performance or clarity improvement
Docs: Documentation updates
Refactor: Code restructuring without functional changes
```

Examples:

- ✅ `Add: Support for SSL/TLS connections`
- ✅ `Fix: Incorrect channel message relay`
- ❌ `update stuff`
- ❌ `asdf`

## Project Structure

```
raychd/
├── config/              # Configuration files
├── logs/                # Server logs
├── src/                 # Source code
├── start.sh             # Start server script
├── stop.sh              # Stop server script
├── Dockerfile           # Docker configuration
├── README.md            # Project overview
└── CONTRIBUTING.md      # This file
```

## Getting Help

- **Questions**: Open an issue with `[QUESTION]` prefix
- **Documentation**: Check README.md and GETTING_STARTED.md
- **Troubleshooting**: See TROUBLESHOOTING.md
- **Chat**: Join discussions on the project

## License

By contributing to Ray Chad, you agree that your contributions will be licensed under the same license as the project.

## Attribution

Contributors will be recognized in the project documentation and changelog.

---

**Thank you for contributing to Ray Chad!** 🎉

Your efforts help make this project better for everyone.
