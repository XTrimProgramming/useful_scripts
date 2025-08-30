import json

input_file = "input.json"  # Replace with your input JSON file path
output_file = "input__sorted.json"  # Replace with your output JSON file path


def sort_json_keys(input_file, output_file):
    # Read the JSON file
    with open(input_file, "r") as file:
        data = json.load(file)

    # Sort the JSON data with keys in alphabetical order
    sorted_data = sort_keys(data)

    # Write the sorted JSON to the output file
    with open(output_file, "w") as file:
        json.dump(sorted_data, file, indent=4)


def sort_keys(data):
    if isinstance(data, dict):
        # Sort dictionary keys recursively
        return {key: sort_keys(value) for key, value in sorted(data.items())}
    elif isinstance(data, list):
        # Apply sorting to each item in the list
        return [sort_keys(item) for item in data]
    else:
        # Return data if it's not a dict or list
        return data


sort_json_keys(input_file, output_file)
print(f"Sorted JSON saved to {output_file}")
