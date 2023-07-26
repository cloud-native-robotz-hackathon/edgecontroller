# Purpose of this Containerfile is for local development / test only.
# Build: podman build -t mkdocs:local --no-cache -f Containerfile.local-run .
# Run: podman run -ti --rm -v $(pwd):/opt/app-root/src:z -p 8080:8080 mkdocs:local
#
FROM registry.access.redhat.com/ubi9/python-39:latest AS builder
LABEL "io.openshift.s2i.build.image"="registry.access.redhat.com/ubi9/python-39:latest" \
      "io.openshift.s2i.build.commit.author"="Robert Bohne <robert.bohne@redhat.com>"

USER root

# Copying in source code
COPY . /tmp/src
# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/src
USER 1001

RUN /usr/libexec/s2i/assemble

CMD python3.9 /opt/app-root/src/server.py