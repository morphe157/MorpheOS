let
  text = ''
    " f -> just like f but more intelligent
    bindurl .*.slack.com --mode=normal f hint -Jc div[data-sidebar-link-id]:not([data-sidebar-link-id=""]),div[data-section-channel-index]:not([data-section-channel-index=""]),button,a

    " v -> select and copy the message
    bindurl .*.slack.com --mode=normal v composite hint -pipe div[data-qa=message-text] | js -p navigator.clipboard.writeText(JS_ARG.innerText)

    " ;n -> compose new message
    bindurl .*.slack.com --mode=normal ;n hint -Jc button[data-qa=composer_button]

    " ;q quote selected message
    bindurl .*.slack.com --mode=normal ;q composite hint -pipe div[data-qa=message-text] | js -p navigator.clipboard.writeText(JS_ARG.innerText.split('\n').map(it => `> ''${it}`).join('\n')); hint -c div[data-qa=message_input]

    " ;u -> open unreads
    bindurl .*.slack.com --mode=normal ;u hint -Jc div[data-sidebar-link-id="Punreads"]

    " ;t -> open all threads
    bindurl .*.slack.com --mode=normal ;t hint -Jc div[data-sidebar-link-id="Vall_threads"]

    " ;d -> open all dms
    bindurl .*.slack.com --mode=normal ;d hint -Jc div[data-sidebar-link-id="Pdms"]

    " ;a -> open activity window
    bindurl .*.slack.com --mode=normal ;a hint -Jc div[data-sidebar-link-id="Pactivity"]

    " ;m -> interactively select a message and open message actions
    bindurl .*.slack.com ;m composite hint -Jc div[class=c-message_kit__gutter]; hint -Jc button[data-qa=more_message_actions]; hint -Jc button[data-focus-key=message_actions],[role=menuitem]

    " ;e -> interactively select a message and edit the selected message
    bindurl .*.slack.com ;e composite hint -Jc div[class=c-message_kit__gutter]; hint -Jc button[data-qa=more_message_actions]; hint -Jc button[data-qa=edit_message]

    " ;c -> interactively select a message and copy the link of selected message
    bindurl .*.slack.com ;c composite hint -Jc div[class=c-message_kit__gutter]; hint -Jc button[data-qa=more_message_actions]; hint -Jc button[data-qa=copy_link]


  '';
in
{
  home.file.".tridactylrc" = {
    enable = true;
    inherit text;
  };
}
