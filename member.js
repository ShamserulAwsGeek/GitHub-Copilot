function SkillsMember(name, skills) {
    this.name = name;
    this.skills = skills;

    this.addSkill = function(skill) {
        this.skills.push(skill);
    };

    this.getSkills = function() {
        return this.skills;
    };
}

// Example usage:
const member = new SkillsMember('John Doe', ['JavaScript', 'HTML']);
member.addSkill('CSS');
console.log(member.getSkills()); // Output: ['JavaScript', 'HTML', 'CSS']