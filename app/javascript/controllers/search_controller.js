import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "suggestions"]

    connect() {
        console.log("Search controller connected")
    }

    input(event) {
        const query = event.target.value.trim()
        console.log("Search input:", query)

        if (query.length < 2) {
            this.hideSuggestions()
            return
        }

        this.fetchSearchSuggestions(query)
    }

    async fetchSearchSuggestions(query) {
        try {
            // Fetch suggestions from the search_logs/final_logs endpoint
            const response = await fetch('/search_logs/final_logs')
            if (!response.ok) {
                throw new Error('Network response was not ok')
            }

            const searchLogs = await response.json()

            // Extract search queries from the logs
            const suggestions = searchLogs.map(log => log.search_query)

            // Filter suggestions based on query
            const filteredSuggestions = suggestions.filter(item =>
                item && item.toLowerCase().includes(query.toLowerCase())
            )

            console.log("Filtered suggestions:", filteredSuggestions)
            this.showSuggestions(filteredSuggestions)
        } catch (error) {
            console.error("Error fetching suggestions:", error)
            this.hideSuggestions()
        }
    }

    showSuggestions(suggestions) {
        const suggestionsTarget = this.suggestionsTarget
        suggestionsTarget.innerHTML = ""

        if (suggestions.length === 0) {
            this.hideSuggestions()
            return
        }

        suggestions.forEach(suggestion => {
            const div = document.createElement("div")
            div.classList.add("suggestion-item")
            div.textContent = suggestion
            div.addEventListener("click", () => this.selectSuggestion(suggestion))
            suggestionsTarget.appendChild(div)
        })

        suggestionsTarget.style.display = "block"
    }

    hideSuggestions() {
        this.suggestionsTarget.style.display = "none"
    }

    selectSuggestion(suggestion) {
        this.inputTarget.value = suggestion
        this.hideSuggestions()
    }
}