import re


def transpile_ideavimrc(input_file, output_file):
    with open(input_file, "r") as file:
        lines = file.readlines()

    which_key_descriptions = []
    key_bindings = []
    in_key_mappings = False

    for line in lines:
        # Check if we are in the Key mappings section
        if line.startswith('"" Key mappings'):
            in_key_mappings = True
            continue

        # If we are in key mappings, separate which-key descriptions
        if in_key_mappings:
            if line.startswith("let g:WhichKeyDesc_"):
                which_key_descriptions.append(line)
            elif (
                line.startswith("map")
                or line.startswith("nnoremap")
                or line.startswith("vnoremap")
            ):
                key_bindings.append(line)
        else:
            # Write lines before the Key mappings section
            key_bindings.append(line)

    # Write the output file
    with open(output_file, "w") as file:
        # Write the which-key descriptions first
        file.write('"" Which-key Descriptions\n')
        file.write('"" ========================================================\n')
        for desc in which_key_descriptions:
            file.write(desc)
        file.write("\n")

        # Write the key bindings
        file.write('"" Key mappings\n')
        file.write('"" ========================================================\n')
        for binding in key_bindings:
            file.write(binding)

    print(f"Transpilation complete. Output written to {output_file}")


# Example usage
if __name__ == "__main__":
    input_file_path = "../custom.ideavimrc"
    output_file_path = "../.ideavimrc"
    transpile_ideavimrc(input_file_path, output_file_path)
