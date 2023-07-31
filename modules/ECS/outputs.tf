output "ecs_clusters_arn" {
  value = aws_ecs_cluster.ecs_cluster.*.arn
}

output "task_defs_arn" {
  value = aws_ecs_task_definition.ecs_task_definition.*.arn
}


output "ecs_clusters_id" {
  value = aws_ecs_cluster.ecs_cluster.*.id
}
