import re
from collections import Counter

# Parse log file
def parse_log(log_file_path):
    with open(log_file_path, 'r') as file:
        log_lines = file.readlines()
    return log_lines

# Count 404 errors
def count_404_errors(log_lines):
    return sum(' 404 ' in line for line in log_lines)

# Get the most requested pages
def get_most_requested_pages(log_lines):
    page_counter = Counter()

    for line in log_lines:
        match = re.search(r'\"[A-Z]+ (.+?) HTTP', line)
        if match:
            page_counter[match.group(1)] += 1

    return page_counter.most_common(5)

# Get IP addresses with the most requests
def get_top_ip_addresses(log_lines):
    ip_counter = Counter()
  
    for line in log_lines:
        match = re.search(r'^(\S+)', line)
        if match:
            ip_counter[match.group(1)] += 1

    return ip_counter.most_common(5)

# Generate report
def generate_report(log_file_path):
    log_lines = parse_log(log_file_path)
    num_404_errors = count_404_errors(log_lines)
    most_requested_pages = get_most_requested_pages(log_lines)
    top_ip_addresses = get_top_ip_addresses(log_lines)

    print("Web Server Log Analysis Report")
    print(f"Number of 404 errors: {num_404_errors}")
    print("Most requested pages:")
  
    for page, count in most_requested_pages:
        print(f"  {page} - {count} requests")
    print("IP addresses with the most requests:")
  
    for ip, count in top_ip_addresses:
        print(f"  {ip} - {count} requests")

# Replace 'access.log' with your log file path
log_file_path = 'access.log'
generate_report(log_file_path)