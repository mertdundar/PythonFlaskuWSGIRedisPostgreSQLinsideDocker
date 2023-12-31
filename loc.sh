#!/bin/bash
#
# Show user stats (commits, files modified, insertions, deletions, total
# lines modified, and total lines added overall) for a repo
# excluded files DO NOT change the commit number, only the files and lines 
# modified are affected by excluded files

git_log_opts=( "$@" )

git log "${git_log_opts[@]}" --format='author: %ae' --numstat --no-merges \
	| tr '[A-Z]' '[a-z]' \
    | grep -v '^$' \
    | grep -v '^-' \
	| grep -v -E '*.py|*.sh|*.yml|*.html|*.txt|*.crt|*.csr|*.key|*.ico|*.service|*.ini|*.json|*.jpg|*.md' \
    | awk '
        {
            if ($1 == "author:") {
                author = $2;
                commits[author]++;
            } else {
                insertions[author] += $1;
                deletions[author] += $2;
                total[author] += $1 + $2;
				totalAdded[author] += $1 - $2;
                # if this is the first time seeing this file for this
                # author, increment their file count
                author_file = author ":" $3;
                if (!(author_file in seen)) {
                    seen[author_file] = 1;
                    files[author]++;
                }
            }
        }
        END {
            # Print a header
            printf("%-50s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n",
                   "Email", "Commits", "Files",
                   "Insertions", "Deletions", "Total Lines", "Total Lines Added");
            printf("%-50s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n",
                   "-----", "-------", "-----",
                   "----------", "---------", "-----------", "-----------");
            
            # Print the stats for each user, sorted by total lines
            n = asorti(total, sorted_emails, "@val_num_desc");
            for (i = 1; i <= n; i++) {
                email = sorted_emails[i];
                printf("%-50s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\t%-10s\n",
                       email, commits[email], files[email],
                       insertions[email], deletions[email], total[email], totalAdded[email]);
            }
        }
'