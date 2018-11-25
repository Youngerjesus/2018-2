pragma solidity ^0.5.0;

// 스터디를 생성할 수 있는 계약
//
contract Study {

	// 스터디에 대한 명세
	// 1. 스터디 이름
	// 2. 스터디 설명
	// 3. 스터디 관리자 - 주소
	// 4. 스터디 참여자 목록 - 주소 리스트
	// 5. 스터디 참여자 개별 잔고
	// 6. 스터디 잔고 (토큰으로 할 예정이기 때문에) 0으로 초기화 생각해야하나?
	// 7. 관리자 보증금
	// 8. 과제 구조체
	//    8.1. 과제 이름
	//    8.2. 과제 설명
	//    8.3. 과제 기한
	//    // 8.4. extendApprovers - 보류
	// 9. 스터디 모집 시작 시기
	// 10. 스터디 모집 종료 시기
	// 11. 모집중인지 여부 (T/F)
	// 12. 과제 목록 - 과제 구조체 리스트

    string name;
    string description;
    
    address public manager;
    address[] public members;
    mapping(address => uint) memberBalance;
    uint balance;
    uint studyDeposit;
    
    struct Assignment {
        uint due;
        string name;
        string description;
        //uint extendApprovers;
    }
    
    uint public recruitStart;
    uint public recruitEnd;
    bool recruiting;
    Assignment[] public assignments;
    
    // 스터디 시스템 설정
    // 1. 관리자 권한 한정자 (manager가 아니면 할 수 없게 함)
    // 2. 생성자 - uint로 일수를 받음
    //    2.1. 계약 호출자를 관리자로 설정
    //    2.2. 모집 시작시기를 호출시기로 설정
    //    2.3. 모집 종료시기를 시작시기로부터 일수만큼 더한 시기로 설정
    //    2.4. 모집중을 참으로 설정 

    modifier onlyManager {
        require(msg.sender == manager);
        _;
    }
    
    constructor (uint n) public {
        manager = msg.sender;
        recruitStart = now;
        recruitEnd = recruitStart + n*1 days; 
        recruiting = true;
    }
    
    /* 모집기간 종료일자 어떤 값으로 넣어야 하는지 정해지면 이걸로 바꿔보도록 하자.
    //
    constructor (uint _recruitDueDate, uint _studyDueDate, uint _studyDeposit) {
        recruitDueDate = _recruitDueDate;
        studyDueDate = _studyDueDate;
        studyDeposit = _studyDeposit;
	}

    modifier recruit {
        require(recruitDueDate > now);
        _;
    }

    function joinStudy() public payable {
        require(msg.value == studyDeposit);
        address(this).tranfer(msg.value);
    }
	*/

    // 스터디 기능 설정
    // 1. 모집 종료
    //    1.1. 관리자만 호출할 수 있음
    //    1.2. 현재 시간이 모집 종료시간이거나 혹은 그 후여야 함
    //    1.3. 모집중을 거짓으로 설정
    //
    // 2. 스터디 참여
    //    2.1. 이더를 받는 함수임
    //    2.2. 송금하는 이더가 2.0001 이상이어야 함
    //    2.3. 이미 스터디 구성원이 아니어야함
    //    2.4. 모집기간이어야 함
    //    2.5. 주소에 할당된 매핑값을 참으로 바꿈 (이거 주소 설정했을 때 기본값이 거짓인지 검증 필요. 2.3.과 같이 고민해봐야)
    //    2.6. 멤버 배열에 주소를 넣음
    //    // 매핑 따로 할 필요가 있는지 고민해봐얄듯??
    // 
    // 3. 과제 설정 - 기한, 이름, 설명을 받음
    //    3.1. 관리자만 호출할 수 있음
    //    3.2. 과제 구조체를 만들어 기한, 이름, 설명을 입력 후 구조체 리스트에 더함
    //
    // 4. 과제 연장 - 보류!
    //

    function recruitingEnd() public onlyManager {
        require(now >= recruitEnd);
        recruiting = false;
    }

    mapping(address=>bool) checkMember;

    function enrollStudy() public payable {
        require(msg.value > 2.00001 ether);
        require(!checkMember[msg.sender]);
        require(recruiting);
        checkMember[msg.sender] = true;
        members.push(msg.sender);
    }

    /* public으로 정의시 기본으로 생기는 함수 (굳이 작성 불필요)
    // 
    function getmembers(uint number) view returns (address[]) {
        return members;
    }
    */

    function newAssignment(uint _due, string memory _name, string memory _description) public onlyManager {
        Assignment memory assignment = Assignment({
            due: _due,
            name: _name,
            description: _description,
         //extendApprovers: 0
        });
        assignments.push(assignment);
    }
    
    /*
    mapping(address => bool) extendApprovers;

    function extendApprove(uint index) public {
        require(extendApprovers[msg.sender] != true);
        assignments[index].extendApprovers += 1;
        extendApprovers[msg.sender] = true;
    }

    function extendAssignment(uint index, uint extendedDue) public onlyManager {
        require(assignments[index].extendApprovers > members.length/2);
        assignments[index].due = extendedDue;
        assignments[index].extendApprovers = 0;
    }
    */



}