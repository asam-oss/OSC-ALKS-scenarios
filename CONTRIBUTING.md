# Contributing Guidelines

As an open-source standardization project, we welcome and encourage the community to submit patches directly to the project.
In our collaborative open source environment, standards and methods for submitting changes help reduce the chaos that can result from an active development community.
This document explains how to participate in project conversations, log bugs and enhancement requests, and submit patches to the project so your patch will be accepted quickly in the codebase.

All IP remains that of the original contributors, and is subject to the original license terms described in the LICENSE file.


# Licensing

This project uses the CC-BY-SA-4.0 License(s) (as found in the LICENSE file in the project’s GitHub repo).

The license tells you what rights you have as a developer, provided by the copyright holder.
It is important that the contributor fully understands the licensing rights and agrees to them.
Sometimes the copyright holder isn’t the contributor, such as when the contributor is doing work on behalf of a company.


# Developer Certification of Origin (DCO)

To make a good faith effort to ensure licensing criteria are met, this project requires the Developer Certificate of Origin (DCO) process to be followed.
The DCO is an attestation attached to every contribution made by every developer.
In the commit message of the contribution, (described more fully later in this document), the developer simply adds a Signed-off-by statement and thereby agrees to the DCO.
When a developer submits a patch, it is a commitment that the contributor has the right to submit the patch per the license.
The DCO agreement is shown below and online.

```
Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the
    best of my knowledge, is covered under an appropriate open
    source license and I have the right under that license to
    submit that work with modifications, whether created in whole
    or in part by me, under the same open source license (unless
    I am permitted to submit under a different license), as
    Indicated in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including
    all personal information I submit with it, including my
    sign-off) is maintained indefinitely and may be redistributed
    consistent with this project or the open source license(s)
    involved.'
```

## DCO Sign-Off Methods

The DCO requires a sign-off message in the following format appear on each commit in the pull request:

`Signed-off-by: Firstname Lastname <email@address.com>`

The DCO text can either be manually added to your commit body, or you can add either `-s` or `--signoff` to your usual Git commit commands.
If you forget to add the sign-off you can also amend a previous commit with the sign-off by running git commit `--amend -s`.
You can add sign-offs to multiple commits (including commits originally authored by others, if you are authorized to do so) using `git rebase --signoff`.
If you’ve pushed your changes to GitHub already you’ll need to force push your branch after this with `git push --force-with-lease`.
If you want to be reminded to add the sign-off for commits in your repository, you can add the following commit-message git hook to your repository:


```bash
#!/bin/sh
#
# Check for DCO/Signed-off-by in message
#

if ! grep -q "^Signed-off-by: " "$1"
then
  echo "Aborting commit: Commit message is not signed off" >&2
  exit 1
fi
```

Placing this script into a file called `.git/hooks/commit-msg` and making it executable (e.g. using `chmod a+x .git/hooks/commit-msg` on unixoid operating systems) will prevent commits without a sign-off.
