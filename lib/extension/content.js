// wait for the page to be ready
window.onload = () => {
	// Listen for messages sent from the background script
	chrome.runtime.onMessage.addListener(message => {
		console.log(message); // Output: { message: "Hello from the background script!" }
	});
	setTimeout(() => {
		domSetup()
	}, 5000)
}

// Setup the DOM elements in the view
function domSetup() {
  const meta_data = document.querySelector("#above-the-fold > #title");
  // create the div for the button
  const check_validity = document.createElement("button");
  check_validity.className = "caption-validity";
	check_validity.style.fontSize = "14px"
  // The fetch button and styles
	const validity_fetch = document.createElement("div");
  validity_fetch.textContent = "Check Validity";
	validity_fetch.style.cursor = "pointer"
	validity_fetch.style.width = "fit-content"
	// content section
	const content = document.createElement("div");
	content.className = "caption-validity-content";
	content.style.fontSize = "14px"

	// add to the yt gruop
	check_validity.appendChild(validity_fetch);
	meta_data.appendChild(check_validity);
	meta_data.appendChild(content);

  // add event listener to the button
  check_validity.addEventListener("click", () => fetch_valdity_data(split_url(window.location.href)));
}

// Get Youtube video id
function split_url(currentUrl) {
	return currentUrl.split("=")[1]
}

// Check validity of video
function fetch_valdity_data(video_id) {
	const validity_fetch_button = document.querySelector(".caption-validity");
	validity_fetch_button.disabled = true

	const validity_content = document.querySelector(".caption-validity-content");
	
	fetch(`http://localhost:4000/api/validate/${video_id}`)
  .then(response => {
    if (response.ok) {
      return response.text();
    } else {
      throw new Error("Error: " + response.statusText);
    }
  })
  .then(data => {
		const { score, desc } = JSON.parse(data)
		// add button to the parent validity group
		validity_content.innerHTML = `${score} | ${desc}`
		validity_fetch_button.disabled = false
  })
  .catch(error => {
    console.error(error);
		validity_fetch_button.disabled = false
  });
}

