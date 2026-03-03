const dc_activity_state = document.getElementById ("activity-state");
const dc_activity_details = document.getElementById ("activity-details");
const dc_activity_image = document.getElementById ("activity-image");
const dc_activity = document.getElementById("activity");

// Fetch lanyard api
(async () => 
		{
			 const baseurl="https://api.lanyard.rest"
			 fetch(baseurl + "/v1/users/878423404275990529")
				 .then (res => res.json ())
				 .then (data => 
					 {
						if (!data["success"])
						  {
							console.error ("Lanyard failed")
							return
						  }

						 // User status
						 data = data["data"];

						 // Media status
						if (data["activities"])
						  {
							data["activities"].forEach (item => {
								if ("name" in item && item["name"] == "Feishin")
								  {
									if  ("state" in item || "details" in item || "assets" in item){
									 
										dc_activity_state.innerText = item["state"];
								
										dc_activity_details.innerText = item["details"]
										
									  	if ("large_image" in item["assets"])
									  	  {
											// Set image
											let image_url = item["assets"]["large_image"];
											image_url = "http:/" + image_url.split("http")[1].replace("%3A", ":");
											dc_activity_image.style.background = `url(${image_url})`;
										  }
										dc_activity.style.display = "unset";
									} 
								  }
							})
						  }
					 })
			dc_activity.hidden = false;
		})();
