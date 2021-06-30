Do what's show [here](https://docs.microsoft.com/en-us/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-ver15#restore-the-database) but with PowerShell.

Restores to a DB called `main` (and drops it first).

---

Would be a lot easier `Invoke-SqlCmd`, but for https://github.com/MicrosoftDocs/sql-docs/issues/6554