// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DailyJournal {
    struct JournalEntry {
        string[] answers;
        uint256 timestamp;
    }
    
    // Mapping from user address to array of journal entries
    mapping(address => JournalEntry[]) private journalEntries;
    
    // Questions array - these could be made dynamic/upgradeable if needed
    string[10] public questions = [
        "What was the highlight of your day?",
        "What was challenging today?",
        "What are you grateful for?",
        "What did you learn today?",
        "How did you feel overall?",
        "What's your main goal for tomorrow?",
        "Did you exercise today?",
        "How was your productivity?",
        "Did you help someone today?",
        "What could you have done better?"
    ];
    
    // Events
    event EntryAdded(address indexed user, uint256 timestamp);
    
    // Add a new journal entry
    function addEntry(string[] memory _answers) public {
        require(_answers.length == 10, "Must provide exactly 10 answers");
        
        JournalEntry memory newEntry = JournalEntry({
            answers: _answers,
            timestamp: block.timestamp
        });
        
        journalEntries[msg.sender].push(newEntry);
        emit EntryAdded(msg.sender, block.timestamp);
    }
    
    // Get the number of entries for a user
    function getEntryCount() public view returns (uint256) {
        return journalEntries[msg.sender].length;
    }
    
    // Get a specific entry
    function getEntry(uint256 _index) public view returns (string[] memory answers, uint256 timestamp) {
        require(_index < journalEntries[msg.sender].length, "Entry does not exist");
        
        JournalEntry storage entry = journalEntries[msg.sender][_index];
        return (entry.answers, entry.timestamp);
    }
    
    // Get all questions
    function getQuestions() public view returns (string[10] memory) {
        return questions;
    }
    
    // Get entries within a date range
    function getEntriesInRange(uint256 _fromTimestamp, uint256 _toTimestamp) 
        public 
        view 
        returns (string[][] memory answers, uint256[] memory timestamps) 
    {
        uint256 count = 0;
        
        // First, count matching entries
        for (uint256 i = 0; i < journalEntries[msg.sender].length; i++) {
            if (journalEntries[msg.sender][i].timestamp >= _fromTimestamp && 
                journalEntries[msg.sender][i].timestamp <= _toTimestamp) {
                count++;
            }
        }
        
        // Initialize return arrays
        answers = new string[][](count);
        timestamps = new uint256[](count);
        
        // Fill return arrays
        uint256 currentIndex = 0;
        for (uint256 i = 0; i < journalEntries[msg.sender].length && currentIndex < count; i++) {
            if (journalEntries[msg.sender][i].timestamp >= _fromTimestamp && 
                journalEntries[msg.sender][i].timestamp <= _toTimestamp) {
                answers[currentIndex] = journalEntries[msg.sender][i].answers;
                timestamps[currentIndex] = journalEntries[msg.sender][i].timestamp;
                currentIndex++;
            }
        }
        
        return (answers, timestamps);
    }
}