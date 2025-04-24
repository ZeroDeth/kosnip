# Git Submodules in This Project

This project uses git submodules to manage external dependencies. Submodules are repositories nested inside this repository, and they need to be initialized and updated separately from the main repository.

## Current Submodules

- **ansible-role-komodo**: [bpbradley/ansible-role-komodo](https://github.com/bpbradley/ansible-role-komodo)
  - Path: `ansible/roles/ansible-role-komodo`
- **ironicbadger.docker-compose-generator**: [ironicbadger/ansible-role-docker-compose-generator](https://github.com/ironicbadger/ansible-role-docker-compose-generator)
  - Path: `ansible/roles/ironicbadger.docker-compose-generator`

## How to Initialize and Update Submodules

When you clone this repository for the first time, you need to initialize the submodules:

```sh
git submodule update --init --recursive
```

If submodules are added or updated, you can update them with:

```sh
git submodule update --remote --merge
```

## Additional Notes
- Always commit changes to submodule references (the pointer in the main repo) after updating submodules.
- If you are contributing, make sure to update submodules as described above to ensure you have the latest code.
