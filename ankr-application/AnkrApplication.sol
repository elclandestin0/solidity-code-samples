//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AnkrApplication {
    mapping(uint256 => Applicant) private _applicants;
    uint256 private _applicantIndex;

    event Applied(uint256 indexed applicantIndex, Applicant indexed applicant);

    struct Applicant {
        string name;
        string location;
        string expectedSalary;
        string githubRepo;
        address applicantAddress;
    }

    constructor() {
        _applicantIndex = 0;
    }

    function register(
        string memory name_,
        string memory location_,
        string memory expectedSalary_,
        string memory githubRepo_
    ) public {
        Applicant memory newApplicant =
            Applicant(
                name_,
                location_,
                expectedSalary_,
                githubRepo_,
                msg.sender
            );
        _applicants[_applicantIndex++] = newApplicant;
        emit Applied(_applicantIndex, newApplicant);
    }

    function applicantIndex() public view returns (uint256) {
        return _applicantIndex;
    }

    function applicants(uint256 index) public view returns (Applicant memory) {
        return _applicants[index];
    }
}
