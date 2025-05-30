# Dead Simple Maven + Buildah Image to Simplify GitLab Builds

Out of the box (OOTB), you typically need two jobs to get a Java artifact into a Docker registry:
a Maven build job that produces the artifact, and a Docker build job that packages and pushes the image.

With this image, you can omit that complexity and do everything in a single step.

## Why Would You Need This Image?

Because, based on my own experience:

- You either need to push images to a local registry within your CI/CD environment, which can be cumbersome, or
- You have to pre-populate the local registry credentials on the runner or environment, which may not be feasible in many setups.

This image is shared to make the process easier and more streamlined.

---

## User Guide: Branch Naming Convention for Image Builds

To support flexible builds for different Maven and JDK versions, the image build workflow uses branch names to determine which versions to use during the Docker image build.

### How to name your branches

Use the following pattern for branch names:

```
jdk<JavaVersion>-maven<MavenVersion>
```


For example:

- `jdk11-maven363`
- `jdk21-maven391`

These values will be interpreted automatically by the workflow, with hardcoded mapping to specific versions:
- `jdk11` → `11.0.2+9`
- `jdk21` → `21.0.2+13`

You can easily expand this logic in the GitHub Actions workflow if needed.

---

## Supported Examples

| Branch Name       | Java Version  | Maven Version |
|-------------------|---------------|----------------|
| jdk11-maven363    | 11.0.2+9      | 3.6.3          |
| jdk11-maven362    | 11.0.2+9      | 3.6.2          |
| jdk21-maven391    | 21.0.2+13     | 3.9.1          |

> The resulting Docker image will be pushed to Docker Hub with a tag like:
>
> `docker.io/<your-dockerhub-username>/maven-buildah:jdk11-maven363`

---

##️ Default Behavior

If the branch name doesn’t match the expected format, the workflow will fall back to:

- Java Version: `11.0.2+9`
- Maven Version: `3.6.3`

---

## Note on `main` Branch

The `main` branch is intentionally excluded from triggering image builds to avoid accidental deployments or publishing from production code.

---

## How to Use

1. **Create a branch** that follows the naming convention (e.g., `jdk11-maven363`).
2. **Push** your changes to GitHub.
3. The GitHub Action will **automatically build and push** the Docker image with the appropriate versions.
4. **Use the image** in your GitLab CI/CD or any Docker-compatible environment.
5. To support **additional versions**, simply:
   - Push a new branch using the proper naming pattern.
   - Ensure the workflow maps the Java major version to a full version + encoded format (e.g. `21.0.2%2B13`).

---

## 📁 Repository Structure

| File / Folder       | Purpose                                    |
|---------------------|--------------------------------------------|
| `Dockerfile`        | Defines the base image with JDK + Maven + Buildah |
| `.github/workflows/docker-build-push.yaml` | Automates image builds and pushes based on branch naming |
| `.dockerignore`     | Excludes files from the Docker build context |
| `README.md`         | This documentation                         |

---

## Example Pull

```bash
docker pull your-dockerhub-username/maven-buildah:jdk11-maven363
```