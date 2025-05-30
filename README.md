# Dead Simple Maven + Buildah Image to Simplify GitLab Builds

Out of the box (OOTB), you usually need two jobs in your CI pipeline to produce a Java artifact and package it into a Docker image: a Maven build job and a separate Docker build job.

This image combines both steps so you can run Maven builds inside the image itself and build your artifact in one step.

## Why Use This Image?

- Usually, you either have to push images to a local registry within your CI/CD environment, which can be complicated, or  
- You have to pre-configure registry credentials on your runners or environment, which is not always feasible.

This image simplifies that process by packaging Maven, OpenJDK, and Buildah in one.

---

## User Guide: Branch Naming Convention for Image Builds

This repository supports building images with different versions of Java and Maven. To select the versions, use branch names formatted as follows:



```
jdk<JavaVersion>-maven<MavenVersion>
```


### Examples

| Branch Name        | Java Version | Maven Version |
|--------------------|--------------|---------------|
| `jdk11-maven3.6.3` | 11           | 3.6.3         |
| `jdk17-maven3.8.6` | 17           | 3.8.6         |
| `jdk21-maven3.9.0` | 21           | 3.9.0         |

- When pushing to a branch like `jdk11-maven3.6.3`, the GitHub Action will build an image using OpenJDK 11 and Maven 3.6.3.
- Branches that don’t follow this naming pattern will cause the workflow to fail, to prevent ambiguous builds.
- The `main` branch does **not** trigger image builds to avoid accidental builds on production code.

---

## How to Use

1. Create or checkout a branch with the naming convention, e.g., `jdk11-maven3.6.3`.
2. Push your code to GitHub.
3. The GitHub Actions workflow will automatically build and push a Docker image tagged with the corresponding Java and Maven versions.
4. Use this image directly in your GitLab CI or any other pipeline, no need for a separate Maven build step.

---

## Docker Hub Credentials

Make sure to add your Docker Hub username and access token as GitHub repository secrets:

- `DOCKERHUB_USERNAME`  
- `DOCKERHUB_TOKEN`

These are used by the workflow to authenticate and push the image.

---

If you want to support additional Java or Maven versions, simply add the corresponding tags in your branch names and update the workflow if needed.

# MIT License

https://opensource.org/licenses/MIT