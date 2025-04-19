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

        // Log the search query (not as a final query)
        this.logSearch(query, false)
    }

    // Handle form submission for search
    search(event) {
        event.preventDefault()
        const query = this.inputTarget.value.trim()

        if (query.length > 0) {
            // Log the search as a final query
            this.logSearch(query, true)
            // Redirect to the articles page with the query
            this.performSearch(query)
        }
    }

    // Method to navigate to articles page with search query
    performSearch(query) {
        window.location.href = `/articles?query=${encodeURIComponent(query)}`
    }

    // Add a method to log searches to the server
    async logSearch(query, isFinalQuery = false) {
        try {
            const response = await fetch('/search_logs', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'X-CSRF-Token': this.getCSRFToken()
                },
                body: JSON.stringify({
                    search_log: {
                        search_query: query,
                        is_final_query: isFinalQuery
                    }
                })
            })

            if (!response.ok) {
                throw new Error('Failed to log search')
            }

            console.log('Search logged successfully')
            return await response.json()
        } catch (error) {
            console.error('Error logging search:', error)
        }
    }

    // Helper method to get CSRF token
    getCSRFToken() {
        const csrfMeta = document.querySelector('meta[name="csrf-token"]')
        return csrfMeta ? csrfMeta.content : ''
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

        // Log the selected suggestion as a final query
        this.logSearch(suggestion, true)

        // Perform the search with the selected suggestion
        this.performSearch(suggestion)
    }
}