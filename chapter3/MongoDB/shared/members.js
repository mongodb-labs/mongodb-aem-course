// vim: set ft=javascript:
function _printMembersAndPriority(conf){
  var sortedMembers = conf.members.sort(function(a, b){
    var pA = a.priority,
    pB = b.priority;
    if ( pA < pB ) return -1;
    if ( pA > pB ) return 1;
    return 0
  })

  print("ReplicaSet: "+ conf._id);
  sortedMembers.forEach( function(member){
      print("host: " + member.host + ", priority: "+member.priority);
  });
}

function printMembersAndPriority(){
  var conf = rs.conf();
  _printMembersAndPriority(conf);
}
