chrome.tabs.query({ url: "*://youtube.com/watch?v=*" }, tabs => {
    // Send a message to each tab
    tabs.forEach(tab => {
        chrome.tabs.sendMessage(tab.id, { message: "Hello from the background script!" });
    });
});