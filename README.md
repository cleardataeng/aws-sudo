# aws-sudo.sh

## Basic usage

### To assume role

`$(aws-sudo.sh arn:aws:iam::123456789012:role/MyCoolRole)`

### To unset environment variables

`$(aws-sudo.sh clear)`
`$(aws-sudo.sh -x)`

### To run a command in a different role

`aws-sudo.sh -c "terraform apply" arn:aws:iam::123456789012:role/MyCoolRole`

### Provide a session name

`aws-sudo.sh -c "terraform apply" -n gitlab-ci
arn:aws:iam::123456789012:role/MyCoolRole`

### Change from a specific profile

If the role requires switching from a non-default profile:

`aws-sudo.sh -p my-govcloud arn:aws-us-gov:iam::987654321098:role/NotSoCool`

## Advanced usage

aws-sudo.sh supports an optional config file.  By default it looks for
`$HOME/.aws-sudo`.  This can be changed with `-f`.

The config file allows you to:

* setup aliases for role ARNs
* provide defaults for role/session names

### Create a role alias

First add a line like this to `~/.aws-sudo`:

```text
alias MyCoolRole arn:aws:iam::123456789012:role/MyCoolRole
```

Now, save lots of typing: `$(aws-sudo.sh MyCoolRole)`

Optionally, you can provide a role session name with the alias:

```text
alias MyCoolRole arn:aws:iam::123456789012:role/MyCoolRole patrick-edward-brown
```

### Use a default role name

Many accounts have the roles with the same names.  If there's one you
use often, you set it as the default.  Then, aws-sudo.sh will allow
you to change roles by account number.  Add a line like this to
`~/.aws-sudo`:

```text
default role ClearDATA-ReadOnly
```

Now, query like a boss: `$ aws-sudo.sh 368327111885 -c "aws sts
get-caller-identity"`

### Using a default session name

Using a distinct session name makes it easy to find stuff in
CloudTrail.  Add a line like this to `~/.aws-sudo`:

```text
default session_name anarchy-burger
```
