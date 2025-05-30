# Dead Simple Maven + Buildah Image to Simplify GitLab Builds

Out of the box (OOTB), you typically need two jobs to get a Java artifact into a Docker registry:
a Maven build job that produces the artifact, and a Docker build job that packages and pushes the image.

With this image, you can omit that complexity and do everything in a single step.

## Why Would You Need This Image?

Because, based on my own experience:

 * You either need to push images to a local registry within your CI/CD environment, which can be cumbersome, or

 * You have to pre-populate the local registry credentials on the runner or environment, which may not be feasible in many setups.

This image is shared to make the process easier and more streamlined.

# User Guide: Branch Naming Convention for Image Builds

To support flexible builds for different Maven, JDK, or Buildah versions, the image build workflow uses branch names to determine which versions to use during the Docker image build.

## How to name your branches for working builds

The branch name should include identifiers for the versions you want embedded in the image. The workflow parses the branch name to select the correct versions.

Example branch name pattern:

```
jdk<JavaVersion>-maven<MavenVersion>
```

## Supported examples

|Branch name	|Java Version	|Maven Version|
|---------------|-----------|-----|
|jdk11-maven363	|11.0.2+9	|3.6.3|
|jdk11-maven362	|11.0.2+9	|3.6.2|

 * If you push code to jdk11-maven363, the GitHub Action will build an image with OpenJDK 11.0.2+9 and Maven 3.6.3.

 * If you push to jdk11-maven362, it will build with OpenJDK 11.0.2+9 and Maven 3.6.2.

## Default behavior

If your branch name doesn’t match any known pattern, the workflow defaults to:

 * Java Version: 11.0.2+9

 * Maven Version: 3.6.3

## Note on the main branch

The main branch does not trigger image builds by default. This avoids building images unintentionally from your stable production branch.

## How to Use

 1 Create or checkout a branch following the naming convention above (e.g., jdk11-maven363).

 2 Push your code.

 3 The GitHub Action workflow will automatically build and push the Docker image tagged with the branch name and versions.

 4 Pull and use the image in your GitLab CI or elsewhere without worrying about Maven build setup inside your pipeline.

 5 If you want to add support for more versions, just update the GitHub Actions workflow to parse those branch names accordingly.