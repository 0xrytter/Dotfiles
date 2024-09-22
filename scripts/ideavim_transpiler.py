def transpile_ideavimrc(input_file, output_file):
    with open(input_file, "r") as file:
        lines = file.readlines()

    which_key_descriptions = []
    key_bindings = []
    base_settings = []
    other_settings = []

    print("Reading input file:", input_file)

    for line in lines:
        stripped_line = line.strip()
        print("Processing line:", stripped_line)

        # Check the starting pattern of the line
        if stripped_line.startswith("let g:WhichKeyDesc"):
            which_key_descriptions.append(line)
        elif stripped_line.startswith("map"):
            key_bindings.append(line)
        elif stripped_line.startswith(
            ("nmap", "nnoremap", "vnoremap", "inoremap", "autocommand", "sethandler")
        ):
            base_settings.append(line)
        elif stripped_line.startswith(('"', "'")) or not stripped_line:
            # Ignore comments and empty lines
            continue
        else:
            other_settings.append(line)

    print("Writing output file:", output_file)

    # Write the output file
    with open(output_file, "w") as file:
        # Write base settings
        file.write('"" Base Settings\n')
        file.write('"" ========================================================\n')
        for setting in base_settings:
            file.write(setting)

        # Write other settings
        file.write('\n"" Other Settings\n')
        file.write('"" ========================================================\n')
        for setting in other_settings:
            file.write(setting)

        # Write the which-key descriptions
        file.write('\n"" Which-key Descriptions\n')
        file.write('"" ========================================================\n')
        for desc in which_key_descriptions:
            file.write(desc)

        # Write the key bindings
        file.write('\n"" Key Bindings\n')
        file.write('"" ========================================================\n')
        for binding in key_bindings:
            file.write(binding)

    print("Transpilation complete. Output written to", output_file)


# Example usage
if __name__ == "__main__":
    input_file_path = "../custom.ideavimrc"
    output_file_path = "../.ideavimrc"
    transpile_ideavimrc(input_file_path, output_file_path)
