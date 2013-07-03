# Generates blank emails for testing.
# Generates 44,000 valid-but-empty emails for testing.

MAILDIR="/home/user/Mail"
# "#mh/Mailbox" is prepanded automatically.
# NOTE: You have to start Claws Mail and create this folder ahead of time.
TEST_FOLDER="/aaa"

# ----
# Setup
# ----

TEST_MAIL=$(cat <<HEREDOC
X-Claws-Account-Id:13
S:user@localhost
SCF:#mh/Mailbox/sent
X-Claws-Sign:0
X-Claws-Encrypt:0
X-Claws-Privacy-System:
X-Claws-Auto-Wrapping:1
X-Claws-Auto-Indent:1
X-Claws-End-Special-Headers: 1
Date: Mon, 15 Jun 2009 08:58:06 -0700
From: user <user@localhost>
Message-ID: <20090615085806.5d620e69@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
HEREDOC
)

# Get claws-mail to exit
# TODO: Only attempt to exit it if it's started.
\claws-mail --exit
# I'm not sure how quirky Claws will be, maybe we need to sleep?
# sleep 2

# ----
# Generate lots of emails
# ----

cd $MAILDIR/$TEST_FOLDER
# TODO: Ensure the CD actually worked.

for i in {1..44000}; do
# for i in {1..3}; do
  if [ ! -f $i ]; then
    echo Generating mail $i
    echo "$TEST_MAIL" > $i
  fi
done

# ----
# Test
# ----

\claws-mail --select "#mh/Mailbox$TEST_FOLDER"
# If you use the Trayicon plugin and have Claws start minimized, it's an extra click to show Claws again.  I could probably hack a solution, but I won't.

INSTRUCTIONS=$(cat <<HEREDOC
INSTRUCTIONS

1. Click on any message in the list of messages.
2. Press <end>
3. Press <shift>-<pageup>
4. Press <delete>

repeat steps 3-4
HEREDOC
)

echo ""
echo ""
echo ""
echo ""
echo $INSTRUCTIONS

# ----
# Teardown
# ----

# N/A, since I can't automatically create the working folder in the first place.

:<< NOTES

I can't create my own directory in some simple way.. the user has to manually create it.

0-byte file:
.mh_sequences

~/.claws-mail/folderlist.xml
<folderitem last_seen="0" order="0" watched="0" ignore="0" locked="0" forwarded="0" replied="0" total="0" marked="0" unreadmarked="0" unread="0" new="0" mtime="0" sort_type="ascending" sort_key="date" hidereadmsgs="0" threaded="1" thread_collapsed="0" collapsed="0" path="TESTINGTHIS" name="TESTINGTHIS" type="normal" />

ugh, maybe more.

NOTES
