# Pretty Good Secure Folder

This is a Flutter application that allows you to securely store and manage sensitive information in encrypted "Vaults".

## Basic Concept

The application is designed around the idea of holding key-value pair objects in a secure manner.

-   **Vaults**: You can organize your data into separate containers called "Vaults". Each Vault has a name and contains a list of key-value items.
-   **Encrypted Storage**: Every value you save is encrypted using Isar's built-in encryption, ensuring that your data remains private and secure on your device.

## How to Use

### Main Screen

The main screen displays a list of all your created Vaults. From here, you can create, view, edit, or delete Vaults.

### Creating a New Vault

1.  Tap the "Create New Vault" button at the bottom of the main screen.
2.  A dialog will appear prompting you to enter a name for your new Vault.
3.  After entering a name and confirming, you will be taken to the "Create" screen.
4.  On this screen, you can add multiple key-value pairs to your new Vault.
5.  Once you are done adding items, tap the "Save" button to create the Vault.

### Viewing and Editing a Vault

1.  From the main screen, simply tap on any Vault in the list.
2.  This will navigate you to the "Edit" screen, where you can view, add, or remove the key-value items within that Vault.

### Deleting a Vault

1.  On the main screen, swipe left on the Vault you wish to delete.
2.  A "Delete" button will appear. Tapping it will permanently remove the Vault and all of its contents.

## License

This project is licensed under the MIT License.


